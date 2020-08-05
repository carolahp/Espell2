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
		'metaclass',
		'layout',
		'role'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
EP2MClass class >> layout: aClass [ 
	layout := aClass
]

{ #category : #instanciation }
EP2MClass class >> named: aString parent: anEP2MLanguage [ 
	^ self basicNew
		name: aString asSymbol;
		parent: anEP2MLanguage;
		initialize;
		yourself
]

{ #category : #'accessing slots' }
EP2MClass >> addSlot: aString [ 
	^ self layout addSlot: aString to: self
		
]

{ #category : #'default model values' }
EP2MClass >> defaultMethodDictionary [
	^ IdentityDictionary new 
]

{ #category : #'accessing layout' }
EP2MClass >> format [
	
	"A class format is composed by"
	"<5 bits inst spec><16 bits inst size>"

	self isImmediate ifTrue:
		[^ self parent formatOfImmediate ].
	
	^ self instSpec << 16 + self instSize
]

{ #category : #initialization }
EP2MClass >> initialize [ 
	super initialize.
	methodDict := self defaultMethodDictionary
]

{ #category : #'accessing header' }
EP2MClass >> instSize [
	self shouldBeImplemented.
]

{ #category : #'accessing header' }
EP2MClass >> instSpec [
	^ self layout instSpec
]

{ #category : #testing }
EP2MClass >> isImmediate [
	^ self parent immediateClassRoles contains: [:rol | rol = self role ]
]

{ #category : #testing }
EP2MClass >> isMetaclass [
	"languages don't have metaclasses by default"
	^ false
]

{ #category : #accessing }
EP2MClass >> layout [
	^ layout
]

{ #category : #'accessing-api' }
EP2MClass >> layout: anEP2LayoutClass [ 
	layout := anEP2LayoutClass
]

{ #category : #'accessing-api' }
EP2MClass >> metaclass [
	^ metaclass
]

{ #category : #accessing }
EP2MClass >> metaclass: anOLClass [ 
	metaclass := anOLClass
]

{ #category : #'accessing model' }
EP2MClass >> methodDict [
	^ methodDict
]

{ #category : #'accessing-api' }
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

{ #category : #accessing }
EP2MClass >> role [
	^ role
]

{ #category : #accessing }
EP2MClass >> role: aString [
	role := aString
]

{ #category : #'accessing-api' }
EP2MClass >> superclass: anEP2MBehavior [
	superclass := anEP2MBehavior 
]
