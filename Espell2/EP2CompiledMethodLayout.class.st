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
	
	^ (self backend 
		object: remote  
		at: anIndex)
]

{ #category : #accessing }
EP2CompiledMethodLayout >> at: anIndex put: aRemoteObject [
	
	self backend 
		object: remote 
		at: anIndex 
		put: aRemoteObject 
]

{ #category : #'gt-extension' }
EP2CompiledMethodLayout >> gtInspectorIn: composite [
	^ composite text
		title: self remote asRemoteCompiledMethod asString;
		display: [ self remote asRemoteCompiledMethod sourceCode ]
]

{ #category : #'gt-extension' }
EP2CompiledMethodLayout >> gtInspectorRawIn: composite [
	^ composite table
		title: [ '*Raw*' ];
		display: [ |literals  bytecodes |
			literals := remote literals collectWithIndex: [ :val :index | ('#literal', index asString) -> val ].
			bytecodes := remote bytecodes asOrderedCollection collectWithIndex: [ :val :index | ('#bc', index asString) -> val ]. 
			literals , bytecodes];
		column: 'Variable'
			evaluated: [:assoc |	assoc key ];
		column: 'Value'
			evaluated: [:assoc | assoc value ].
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
