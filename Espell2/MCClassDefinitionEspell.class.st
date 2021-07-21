Class {
	#name : #MCClassDefinitionEspell,
	#superclass : #MCClassDefinition,
	#instVars : [
		'metaclass'
	],
	#category : #'Espell2-Monticello'
}

{ #category : #accessing }
MCClassDefinitionEspell >> metaclass [
	^ metaclass
]

{ #category : #accessing }
MCClassDefinitionEspell >> metaclass: aClassModel [
	metaclass := aClassModel
]
