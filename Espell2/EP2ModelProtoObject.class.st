Class {
	#name : #EP2ModelProtoObject,
	#superclass : #Object,
	#instVars : [
		'properties',
		'name',
		'parent'
	],
	#category : #'Espell2-Models'
}

{ #category : #accessing }
EP2ModelProtoObject >> properties [

	^ properties ifNil: [ properties := IdentityDictionary new ]
]
