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
	| getter setter ivar |
	ivar := self classVarsIVName.
	getter := ivar, '
	^ ',ivar.
	setter := ivar, ': anObject
	', ivar, ' := anObject'.
	
	^ PhClassModifier new
		on:
			(PhPointcut receivers: self metamodel name selectors: #any asParser);
		addNewInstanceVar: ivar;
		addNewInstanceMethod: getter;
		addNewInstanceMethod: setter;
		yourself
]

{ #category : #constants }
ClassVarsAspect >> classVarsIVName [
	^ #classPool
]

{ #category : #initialization }
ClassVarsAspect >> initialize [
	super initialize.
	self addClassModifier: self classModifier.
	self add: ((PhAdvice new)
					pointcut: ((PhPointcut new)
						receivers: self metamodel name;
						selectors: 'transform';
						context: #(#receiver));
					advice: [ :context | 
						context receiver  ];
					type: #before)
	
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
