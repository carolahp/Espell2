Class {
	#name : #EP2CrossCompilerBinding,
	#superclass : #Object,
	#instVars : [
		'class',
		'environment'
	],
	#category : #'Espell2-Backend'
}

{ #category : #accessing }
EP2CrossCompilerBinding >> allSlots [

	^ class allSlots
]

{ #category : #bindings }
EP2CrossCompilerBinding >> binding [
	
	^ class isMeta ifTrue: [
		EP2MetaclassBinding  new
			name: class theNonMetaClass name; 
			objectSpace: environment objectSpace;
			yourself ] ifFalse: [
		EP2GlobalBinding new
			name: class theNonMetaClass name; 
			objectSpace: environment objectSpace;
			yourself ]
]

{ #category : #accessing }
EP2CrossCompilerBinding >> class: aRGClass [ 
	class := aRGClass
]

{ #category : #accessing }
EP2CrossCompilerBinding >> environment [
	^ environment
]

{ #category : #accessing }
EP2CrossCompilerBinding >> environment: aCompilerEnvironment [ 
	environment := aCompilerEnvironment
]

{ #category : #binding }
EP2CrossCompilerBinding >> innerBindingOf: aString [ 

	(class classVarNames includes: aString asSymbol)
		ifTrue: [ self assert: environment notNil.
			^ EP2ClassVariableBinding new
				name: aString asSymbol
					ownerName: class theNonMetaClass name
					objectSpace: environment;
				yourself ].
	class instanceSide sharedPools
		do: [ :pool | 
			((self newBindingFor: pool) innerBindingOf: aString)
				ifNotNil: [ :binding | ^ binding ] ].
	class superclass
		ifNotNil: [ (self superclassBinding innerBindingOf: aString)
				ifNotNil: [ :binding | ^ binding ] ].

	"If it is a temp or an instance variable"
	^ nil
]

{ #category : #bindings }
EP2CrossCompilerBinding >> newBindingFor: aRGClass [ 
	
	^ self class new
		class: aRGClass;
		environment: environment
]

{ #category : #bindings }
EP2CrossCompilerBinding >> superclassBinding [
	
	^ self newBindingFor: class superclass
]
