"
I define the basic metamodel of classes in a Pharo-like language.
In this description classes are referred by the name of their role.

According to my metamodel: 
	- The metaclass of each class is the a class whose name is the same as mine but with suffix ' class'
	- The metaclass of #'Metaclass' is #'Metaclass class' and 
	  the metaclass of #'Metaclass class' is #'Metaclass' 
=====================================================================
Usage: 
- Subclass me to define the metamodel of classes in your own language.
- In your Language metamodel implement the hook EP2MLanguage>>classMetaclass and return the subclass you just created.
=====================================================================

"
Class {
	#name : #EP2MClassWithImplicitMetaclass,
	#superclass : #EP2MClass,
	#instVars : [
		'metaclass'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #initialization }
EP2MClassWithImplicitMetaclass >> initializeWithMonticello: aMCClassDefinition [
	"A class is instantiated following the monticello definition"
	| mcDef |
self flag:'implenent this'.
	mcDef := aMCClassDefinition.
	self
		layout: (mcDef espell2LayoutType on: self);
		metaclass: self parent classMetaclass;
		template: nil.
	mcDef superclassName = #nil
		ifTrue: [ self halt ]
		ifFalse: [ self superclass: (self parent ensureClassNamed: mcDef superclassName) ].
	mcDef variables
		do: [ :each | 
			"the simplest metamodel considers only instance variables"
			each class type = #instance
				ifTrue: [ "(each class type = #class) ifTrue: [ 
				self addClassVariable: (RGClassVariable named: each name parent: self)].
			(each class type = #classInstance) ifTrue: [ 
				metaclassDef layout addSlot: (RGInstanceVariableSlot named: each name parent: metaclassDef layout)].
			(each class type = #pool) ifTrue: [ 
				self addSharedPool: (RGPoolVariable named: each name parent: self)]."
					(each name includes: $>)
						ifFalse: [ self addSlot: each name ]
						ifTrue: [ | unknownSlot |
							self halt
							"unknownSlot := RGUnknownSlot
								named: ((each name copyUpTo: $=) copyWithout: $#) trimBoth
								parent: self layout.
							unknownSlot expression: (each name copyAfter: $>) trimBoth.
							self layout addSlot: unknownSlot" ] ] ]
	
]

{ #category : #initialization }
EP2MClassWithImplicitMetaclass >> initializeWithTemplate: aTemplateClass [
	super initializeWithTemplate: aTemplateClass.
	"check if we are installing the class with role Class (it is the only class which is instance of itself)"
	self flag:'implenent this'.
	(aTemplateClass role = 'Metaclass') 
		ifTrue: [ metaclass := self ]
		ifFalse: [ metaclass := parent classMetaclass ].
	
	^ self
]
