"
I am an abstract class that defines the metamodel of classes in a bootstrapped language.
Subclass me to define the metamodel of classes in your own language.
Return the reference to your subclass from the hook EP2MLanguage>>classMetaclass.
"
Class {
	#name : #EP2MClass,
	#superclass : #EP2MObject,
	#instVars : [
		'superclass',
		'methodDict',
		'layout',
		'role'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'instance creation' }
EP2MClass class >> named: aString parent: anEP2MLanguage superclass: aEP2MBehavior layout: anEP2LayoutClass [ 
	^ self basicNew
		name: aString;
		parent: anEP2MLanguage;
		superclass: aEP2MBehavior;
		layout: anEP2LayoutClass;
		initialize;
		yourself
]

{ #category : #testing }
EP2MClass >> isMetaclass [
	"languages don't have metaclasses by default"
	^ false
]

{ #category : #accessing }
EP2MClass >> layout: anEP2LayoutClass [ 
	layout := anEP2LayoutClass
]

{ #category : #accessing }
EP2MClass >> metaclass [
	^ self parent metaclassFor: self
]

{ #category : #'accessing-model' }
EP2MClass >> package [
	^ self parent packageFor: self
]

{ #category : #printing }
EP2MClass >> printOn: aStream [
	aStream 
		nextPutAll: '"';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #'accessing-api' }
EP2MClass >> superclass: anEP2MBehavior [
	superclass := anEP2MBehavior 
]
