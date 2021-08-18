Class {
	#name : #LanguageDemo,
	#superclass : #Object,
	#classInstVars : [
		'modelClasses',
		'languageAspect',
		'aspects',
		'membrane0',
		'membrane1',
		'membrane2',
		'language'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
LanguageDemo class >> install [
	self assert: languageAspect isNotNil.
	self assert: aspects isNotNil.
	self assert: aspects isNotEmpty.
	self assert: membrane0 isNotNil.
	self assert: membrane1 isNotNil.
	self assert: membrane2 isNotNil.
	self assert: language isNotNil.
	
	aspects do: [ :asp |
		asp registerOn: membrane1.
		asp registerOn: membrane2 ].
	languageAspect registerOn: membrane1.
	membrane0 deployOn: language
]

{ #category : #'instance creation' }
LanguageDemo class >> installClasses [
	| miClass miMulticlass miSlot |
	self uninstallClasses.
	miClass := self
		newClass: #MIClass
		superclass: ObjVLispMinClass
		slots: {}.
	miMulticlass := self
		newClass: #MIMulticlass
		superclass: miClass
		slots: {}.
	miSlot := self
		newClass: #MISlot
		superclass: InstanceVariableSlotModel
		slots: {}.
	modelClasses := { miClass . miMulticlass . miSlot }
]

{ #category : #'instance creation' }
LanguageDemo class >> languageModelClass [
	^ BaseLanguage
]

{ #category : #'instance creation' }
LanguageDemo class >> newClass: className superclass: aSuperclass slots: slots [
	^ ShiftClassInstaller
		make: [ :builder | 
			builder
				name: className;
				superclass: aSuperclass;
				slots: slots;
				sharedVariables: '';
				sharedPools: '';
				category: self class category, '-', self name ]
]

{ #category : #'instance creation' }
LanguageDemo class >> uninstallClasses [
	modelClasses
		ifNotNil: [ modelClasses do: [ :class | class ifNotNil: #removeFromSystem ] ]
]
