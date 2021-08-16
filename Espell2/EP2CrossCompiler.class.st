Class {
	#name : #EP2CrossCompiler,
	#superclass : #Object,
	#instVars : [
		'objectSpace'
	],
	#category : #'Espell2-Backend'
}

{ #category : #instantiation }
EP2CrossCompiler class >> newCompiler [
	^ EP2Compiler new
]

{ #category : #compiling }
EP2CrossCompiler >> basicCompileDoItFromSourceCode: sourceCode [ 

	| highLevelUndefinedObjectClass |
	
	highLevelUndefinedObjectClass := objectSpace nilObject basicClass.
	
	^ (self class newCompiler
		noPattern: true;
		environment: highLevelUndefinedObjectClass asClassDefinition environment;
		source: sourceCode; 
		class: highLevelUndefinedObjectClass; 
		requestor: objectSpace nilObject; 
		failBlock: [self error]; parse) generate
]

{ #category : #compiling }
EP2CrossCompiler >> basicCompileSourceCode: sourceCode forClass: anEP2CrossCompilerBinding [ 

	| options contextClass compiler ast |
	options := #().
	contextClass := objectSpace backend interpreter codeProvider systemDefinition classContext.
	anEP2CrossCompilerBinding className == contextClass name ifTrue: [ options := #(+ optionLongIvarAccessBytecodes)].
	compiler := self class newCompiler
		options: options;
		class: anEP2CrossCompilerBinding classModel;
		environment: anEP2CrossCompilerBinding classModel environment;
		requestor: nil;
		failBlock: [ self error ].
	"compiler compilationContext parserClass: ".
	ast := compiler source: sourceCode; parse.
	"vars := (ast allVariables select: [:node | node name = #grades and: node isRead ]) .
	accessor := compiler source: 'self grades'; parseExpression.
	vars parent replaceNode: vars withNode: accessor.
	ast."
	
	^ ast generate
]

{ #category : #compiling }
EP2CrossCompiler >> compile: sourceCode forClass: aClass inEnvironment: anEnvironment [
	| localCompiledMethod binding |
	binding := EP2CrossCompilerBinding new
		class: aClass;
		environment: anEnvironment;
		yourself.
	[ localCompiledMethod := self
		basicCompileSourceCode: sourceCode
		forClass: binding ]
		on: OCUndeclaredVariableWarning
		do: [ :e | 
			| tempModelClass tempModel varNode compilationContext |
			compilationContext := e compilationContext.
			varNode := e node.
			tempModelClass := (compilationContext getClass methodDict
				at: varNode methodNode selector) class tempVariableModel.
			(tempModelClass acceptsUndeclaredReferences
				and: [ varNode methodOrBlockNode isBlock not ])
				ifTrue: [ 
					tempModel := (tempModelClass
						named: varNode name
						parent: compilationContext environment)
						index: 0;
						"index 0 means the temp is not defined in the method"
							yourself.
					e resume: (e signaler declareVariableNode: varNode as: tempModel) ]
				ifFalse: [ self error: 'Undeclared Reference: ' , varNode name.
					e
						resume:
							(EP2UndeclaredBinding new
								name: e node name;
								objectSpace: anEnvironment objectSpace;
								yourself) ] ].
	^ localCompiledMethod
		asRemoteObjectInObjectSpace: anEnvironment objectSpace
]

{ #category : #compiling }
EP2CrossCompiler >> compileDoIt: sourceCode [ 
	| localCompiledMethod |
	localCompiledMethod := self basicCompileDoItFromSourceCode: sourceCode.
	^ self translateToRemoteCompiledMethod: localCompiledMethod
]

{ #category : #'creating compiled method' }
EP2CrossCompiler >> createCompiledMethodWithSize: methodSize andHeader: header [ 

	^ objectSpace backend
		createCompiledMethodWithSize: methodSize
		andHeader: header
]

{ #category : #accessing }
EP2CrossCompiler >> objectSpace [
	^ objectSpace
]

{ #category : #accessing }
EP2CrossCompiler >> objectSpace: anEPObjectSpace [ 
	objectSpace := anEPObjectSpace
]

{ #category : #compiling }
EP2CrossCompiler >> transformLiteral: aLiteral asLiteralInObjectSpace: anObjectSpace [ 
	
	aLiteral isMethodProperties ifTrue: [
		"For now we convert method properties in selectors. Careful! We are losing pragmas at bootstrap time!"
		^ aLiteral selector asRemoteObjectInObjectSpace: anObjectSpace 
	].
	^ aLiteral asRemoteObjectInObjectSpace: anObjectSpace  
]

{ #category : #'translating to remote' }
EP2CrossCompiler >> translateToLocalCompiledMethod: remoteCompiledMethod [ 

	| localMethod methodSize |
	methodSize := remoteCompiledMethod bytecode size + CompiledMethodTrailer empty size.
	localMethod := self
						createCompiledMethodWithSize: methodSize
						andHeader: remoteCompiledMethod header.
	localMethod bytecodes: remoteCompiledMethod bytecode.
	remoteCompiledMethod allLiterals withIndexDo: [ :literal :index |
		localMethod literalAt: index put: (self transformLiteral: literal asLiteralInObjectSpace: objectSpace).
	].
	^localMethod
]

{ #category : #'translating to remote' }
EP2CrossCompiler >> translateToRemoteCompiledMethod: localCompiledMethod [ 

	| methodMirror methodSize |
	methodSize := localCompiledMethod bytecode size + CompiledMethodTrailer empty size.
	methodMirror := self
						createCompiledMethodWithSize: methodSize
						andHeader: localCompiledMethod header.
	methodMirror bytecodes: localCompiledMethod bytecode.
	localCompiledMethod allLiterals withIndexDo: [ :literal :index |
		methodMirror literalAt: index put: (self transformLiteral: literal asLiteralInObjectSpace: objectSpace).
	].
	^methodMirror
]
