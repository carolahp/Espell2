Class {
	#name : #EP2CrossCompilerBinding,
	#superclass : #Object,
	#instVars : [
		'class',
		'objectSpace',
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
	^ class binding
	"^ class isMeta ifTrue: [
		EP2MetaclassBinding  new
			name: class theNonMetaClass name; 
			objectSpace: environment objectSpace;
			yourself ] ifFalse: [
		EP2GlobalBinding new
			name: class theNonMetaClass name; 
			objectSpace: environment objectSpace;
			yourself ]"
]

{ #category : #binding }
EP2CrossCompilerBinding >> bindingOf: aString [
	self deprecated: 'Use bindings from ObjectModels'.
	(class classVarNames includes: aString asSymbol)
		ifTrue: [ self assert: environment notNil.
			^ EP2ClassVariableBinding new
				name: aString asSymbol
					ownerName: class theNonMetaClass name
					objectSpace: environment objectSpace;
				yourself ].
	class sharedPools
		do: [ :pool | 
			((self newBindingFor: pool) bindingOf: aString)
				ifNotNil: [ :binding | ^ binding ] ].
	class superclass
		ifNotNil: [ (self superclassBinding bindingOf: aString)
				ifNotNil: [ :binding | ^ binding ] ].
	(environment objectSpace includesClassNamed: aString)
		ifTrue: [ self assert: environment notNil.
			^ EP2GlobalBinding new
				name: aString objectSpace: environment objectSpace;
				yourself ].

	"If it is a temp or an instance variable"
	^ nil
]

{ #category : #accessing }
EP2CrossCompilerBinding >> class: aClassModel [ 
	class := aClassModel
]

{ #category : #accessing }
EP2CrossCompilerBinding >> classModel [
	^ class
]

{ #category : #accessing }
EP2CrossCompilerBinding >> className [
	
	^ class name
]

{ #category : #accessing }
EP2CrossCompilerBinding >> environment [
	^ environment
]

{ #category : #accessing }
EP2CrossCompilerBinding >> environment: aPBImageBuilderGeneric [ 
	environment := aPBImageBuilderGeneric
]

{ #category : #binding }
EP2CrossCompilerBinding >> innerBindingOf: aString [ 
	^ class innerBindingOf: aString asSymbol.
	"(class classVarNames includes: aString asSymbol)
		ifTrue: [ self assert: environment notNil.
			^ EP2ClassVariableBinding new
					name: aString asSymbol
					ownerName: class theNonMetaClass name
					objectSpace: environment objectSpace;
				yourself ].
	class instanceSide sharedPools
		do: [ :pool | 
			((self newBindingFor: pool) innerBindingOf: aString)
				ifNotNil: [ :binding | ^ binding ] ].
	class superclass
		ifNotNil: [ (self superclassBinding innerBindingOf: aString)
				ifNotNil: [ :binding | ^ binding ] ].
	"
	"If it is a temp or an instance variable"
	"^ nil"
]

{ #category : #accessing }
EP2CrossCompilerBinding >> name [
	^ self className
]

{ #category : #bindings }
EP2CrossCompilerBinding >> newBindingFor: aRGClass [ 
	
	^ self class new
		class: aRGClass;
		environment: environment
]

{ #category : #accessing }
EP2CrossCompilerBinding >> simpleClassModel [
	^ class
]

{ #category : #bindings }
EP2CrossCompilerBinding >> superclassBinding [
	
	^ self newBindingFor: class superclass
]
