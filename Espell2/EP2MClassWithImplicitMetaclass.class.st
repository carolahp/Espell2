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
EP2MClassWithImplicitMetaclass >> initializeWithTemplate: aTemplateClass [
	super initializeWithTemplate: aTemplateClass.
	"check if we are installing the class with role Class (it is the only class which is instance of itself)"
	self flag:'implenent this'.
	(aTemplateClass role = 'Metaclass') 
		ifTrue: [ metaClass := self ]
		ifFalse: [ metaClass := parent classMetaclass ].
	
	^ self
]
