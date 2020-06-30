Class {
	#name : #EP2CompiledMethodLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #testing }
EP2CompiledMethodLayout >> at: anIndex [
	
	^ self backend compiledMethod: self objectAt: anIndex
]

{ #category : #testing }
EP2CompiledMethodLayout >> at: anIndex put: anObjectMirror [
	
	self backend compiledMethod: self objectAt: anIndex put: anObjectMirror
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
