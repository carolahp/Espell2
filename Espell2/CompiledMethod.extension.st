Extension { #name : #CompiledMethod }

{ #category : #'*Espell2' }
CompiledMethod >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 

	| methodMirror methodSize |
	methodSize := self bytecode size + CompiledMethodTrailer empty size.
	methodMirror := anEP2ObjectSpace backend
						createCompiledMethodWithSize: methodSize
						andHeader: self header.
	methodMirror bytecodes: self bytecode.
	self allLiterals withIndexDo: [ :literal :index |
		methodMirror literalAt: index put: (anEP2ObjectSpace crossCompiler transformLiteral: literal asLiteralInObjectSpace: anEP2ObjectSpace).
	].
	^methodMirror
]
