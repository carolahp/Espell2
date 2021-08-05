Class {
	#name : #ClassVarsAspect,
	#superclass : #PhAspect,
	#instVars : [
		'metamodel'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
ClassVarsAspect class >> for: aClassModelClass [
	^ self basicNew 
		metamodel: aClassModelClass;
		initialize;
		yourself.
]

{ #category : #'instance creation' }
ClassVarsAspect class >> new [
	self error: 'use >>for:'
]

{ #category : #initialization }
ClassVarsAspect >> classModifier [
	^ PhClassModifier new
		on:
			(PhPointcut receivers: self metamodel name selectors: #any asParser);
		addNewInstanceVar: self classVarsIVName;
		yourself
]

{ #category : #constants }
ClassVarsAspect >> classVarsIVName [
	^ #classPool
]

{ #category : #initialization }
ClassVarsAspect >> initialize [
	super initialize.
	self addClassModifier: self classModifier
	
]

{ #category : #'install-uninstall' }
ClassVarsAspect >> install [
	self assert: (self metamodel hasInstVarNamed: self classVarsIVName) not.
	super install.
	self assert: (self metamodel hasInstVarNamed: self classVarsIVName)
]

{ #category : #accessing }
ClassVarsAspect >> metamodel [
	^ metamodel
]

{ #category : #accessing }
ClassVarsAspect >> metamodel: aClassModelClass [
	metamodel := aClassModelClass
]

{ #category : #'install-uninstall' }
ClassVarsAspect >> uninstall [
	super uninstall.
	self assert: (self metamodel hasInstVarNamed: self classVarsIVName) not
]
