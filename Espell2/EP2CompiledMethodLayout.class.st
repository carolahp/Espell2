Class {
	#name : #EP2CompiledMethodLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2CompiledMethodLayout >> at: anIndex [
	
	^ (self backend 
		object: remote target 
		at: anIndex)
]

{ #category : #testing }
EP2CompiledMethodLayout >> at: anIndex put: aRemoteObject [
	
	self backend 
		object: remote target
		at: anIndex 
		put: aRemoteObject target
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

{ #category : #testing }
EP2CompiledMethodLayout >> isBitsLayout [

	^ true
]

{ #category : #testing }
EP2CompiledMethodLayout >> isByteLayout [

	^ true
]

{ #category : #testing }
EP2CompiledMethodLayout >> isCompiledMethodLayout [

	^ true
]

{ #category : #testing }
EP2CompiledMethodLayout >> isVariableLayout [

	^ true
]

{ #category : #testing }
EP2CompiledMethodLayout >> layoutName [

	^ #CompiledMethodLayout
]
