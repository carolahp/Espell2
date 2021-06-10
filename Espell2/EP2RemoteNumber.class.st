Class {
	#name : #EP2RemoteNumber,
	#superclass : #EP2RemoteMagnitude,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteNumber class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteNumber class >> role [
	^ nil 
	"^ 'Number'"
]

{ #category : #'gt-inspector' }
EP2RemoteNumber >> gtInspectorIn: composite [
	"self object isRoleMetaclass ifTrue: [ self haltOnce. ]."

	^ composite text
		title: self asString;
		display: [ self asString ]
]
