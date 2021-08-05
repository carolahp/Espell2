Class {
	#name : #ClassVarsAspect,
	#superclass : #PhAspect,
	#instVars : [
		'classModifier',
		'metamodel'
	],
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
ClassVarsAspect >> classModifier [
	^ PhClassModifier new
		on:
			(PhPointcut
				receivers: self metamodel name
				selectors: #any asParser)
]

{ #category : #'as yet unclassified' }
ClassVarsAspect >> classVarsIVName [
	^ #classPool
]

{ #category : #'as yet unclassified' }
ClassVarsAspect >> initialize [
	classModifier := self classModifier.
	self assert: (self metamodel hasInstVarNamed: self classVarsIVName) not.
	classModifier addNewInstanceVar: self classVarsIVName.
]

{ #category : #'as yet unclassified' }
ClassVarsAspect >> metamodel [
	^ metamodel
]

{ #category : #'as yet unclassified' }
ClassVarsAspect >> metamodel: aClassModelClass [
	metamodel := aClassModelClass
]
