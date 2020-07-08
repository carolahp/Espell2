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
		title: self remote asString;
		display: [ self remote sourceCode ]
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
