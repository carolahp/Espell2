Class {
	#name : #SharedPoolsAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #accessing }
SharedPoolsAspect >> adviceInnerBindingOf [
	^ PhAdvice new
		pointcut: self pcInnerBindingOf;
		advice: [ :context | 
			| model varName |
			(context dynamicContext).
			model := context receiver.
			varName := (context arguments at: 1) asSymbol.
			(model mySharedPools bindingOf: varName) 
			 ifNil: [ | next |
				next := context currentAdvice asOrderedCollection select: [ :each | each owner class = ClassVarAspect ].
				context currentAdvice: next continueAt: 1.
				context proceed
				]];
		type: #around
]

{ #category : #accessing }
SharedPoolsAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #accessing }
SharedPoolsAspect >> fieldName [
	^ #mySharedPools
]
