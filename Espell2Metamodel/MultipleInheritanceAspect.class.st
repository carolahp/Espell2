Class {
	#name : #MultipleInheritanceAspect,
	#superclass : #PhAspect,
	#instVars : [
		'modelSuperclass',
		'modelClass'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
MultipleInheritanceAspect class >> subclassing: aClassModelClass [
^ self basicNew
		modelSuperclass: aClassModelClass; 
		initialize;
		yourself.
]

{ #category : #accessing }
MultipleInheritanceAspect >> classModifier [
	
	
]

{ #category : #initialization }
MultipleInheritanceAspect >> initialize [ 
	super initialize
	
]

{ #category : #'install-uninstall' }
MultipleInheritanceAspect >> install [
	self assert: (modelSuperclass hasInstVarNamed: #mySlots).
	modelClass ifNotNil: #removeFromSystem.
	modelClass := self newClass: self modelClassName 
		superclass: modelSuperclass 
		slots: {#superclasses => InstanceVariableSlot}.
	super install
]

{ #category : #accessing }
MultipleInheritanceAspect >> modelClassName [
	^ modelSuperclass name, 'Multi'
]

{ #category : #accessing }
MultipleInheritanceAspect >> modelSuperclass: aClassModelClass [
	modelSuperclass := aClassModelClass
]

{ #category : #private }
MultipleInheritanceAspect >> newClass: className superclass: aSuperclass slots: slots [
	^ ShiftClassInstaller
		make: [ :builder | 
			builder
				name: className;
				superclass: aSuperclass;
				slots: slots;
				sharedVariables: '';
				sharedPools: '';
				category: modelSuperclass category ]
]

{ #category : #'install-uninstall' }
MultipleInheritanceAspect >> uninstall [
	super uninstall.
	modelClass ifNotNil: #removeFromSystem.
	
]
