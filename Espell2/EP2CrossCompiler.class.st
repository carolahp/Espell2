Class {
	#name : #EP2CrossCompiler,
	#superclass : #Object,
	#instVars : [
		'objectSpace'
	],
	#category : #'Espell2-Backend'
}

{ #category : #compiling }
EP2CrossCompiler >> basicCompileSourceCode: sourceCode forClass: anEP2CrossCompilerBinding [ 

	| options contextClass |
	options := #().
	contextClass := objectSpace backend interpreter codeProvider systemDefinition classContext.
	anEP2CrossCompilerBinding className == contextClass name ifTrue: [ options := #(+ optionLongIvarAccessBytecodes) ].
	
	^ (OpalCompiler new
		options: options;
		source: sourceCode;
		class: anEP2CrossCompilerBinding;
		environment: anEP2CrossCompilerBinding objectSpace;
		requestor: nil;
		failBlock: [ self error ];
		parse) generate
]

{ #category : #compiling }
EP2CrossCompiler >> compile: sourceCode forClass: aClass inEnvironment: anEnvironment [

	| localCompiledMethod binding |

	binding := EP2CrossCompilerBinding new class: aClass; objectSpace: anEnvironment objectSpace.
	[localCompiledMethod := self basicCompileSourceCode: sourceCode forClass: binding. ]
		on: OCUndeclaredVariableWarning
		do: [ :e | 
			e resume:
				(EP2UndeclaredBinding new
					name: e node name;
					objectSpace: anEnvironment objectSpace;
					yourself) ].
	^ localCompiledMethod asRemoteObjectInObjectSpace: anEnvironment objectSpace
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
		^ aLiteral selector asLiteralInObjectSpace: anObjectSpace 
	].
	^ aLiteral asRemoteObjectInObjectSpace: anObjectSpace  
]
