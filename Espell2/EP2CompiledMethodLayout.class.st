Class {
	#name : #EP2CompiledMethodLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2CompiledMethodLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteCompiledMethod
]

{ #category : #accessing }
EP2CompiledMethodLayout >> at: anIndex [
	
	^ self backend 
		object: object  
		at: anIndex
]

{ #category : #accessing }
EP2CompiledMethodLayout >> at: anIndex put: aRemoteObject [
	
	self backend 
		object: object 
		at: anIndex 
		put: aRemoteObject 
]

{ #category : #'gt-extension' }
EP2CompiledMethodLayout >> gtInspectorIn: composite [
	^ composite text
		title: self object asRemoteCompiledMethod asString;
		display: [ self object asRemoteCompiledMethod sourceCode ]
]

{ #category : #'gt-extension' }
EP2CompiledMethodLayout >> gtInspectorRawIn: composite [
	^ composite table
		title: [ '*Raw*' ];
		display: [ |literals  bytecodes |
			literals := object literals collectWithIndex: [ :val :index | ('(remote) #literal', index asString) -> val ].
			bytecodes := object localBytecodes asOrderedCollection collectWithIndex: [ :val :index | ('#bc ', val asString ) -> ((object backend simulator class bytecodeTable at: val) asString) ]. 
			literals , bytecodes];
		column: 'Variable'
			evaluated: [:assoc |	assoc key ];
		column: 'Value'
			evaluated: [:assoc | assoc value asRemoteObjectCasted ];
		send: [ :assoc | assoc value asRemoteObjectCasted ].
]

{ #category : #'testing-types' }
EP2CompiledMethodLayout >> isBitsLayout [

	^ true
]

{ #category : #'testing-types' }
EP2CompiledMethodLayout >> isByteLayout [

	^ true
]

{ #category : #'testing-types' }
EP2CompiledMethodLayout >> isCompiledMethodLayout [

	^ true
]

{ #category : #'testing-types' }
EP2CompiledMethodLayout >> isVariableLayout [

	^ true
]

{ #category : #accessing }
EP2CompiledMethodLayout >> layoutName [

	^ #CompiledMethodLayout
]

{ #category : #exporting }
EP2CompiledMethodLayout >> mcType [

	^ #compiledMethod 
]
