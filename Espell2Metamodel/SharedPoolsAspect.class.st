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
			model sharedPools bindingOf: varName ];
		type: #around
]

{ #category : #accessing }
SharedPoolsAspect >> defaultFieldValue [
	^ OrderedCollection new
]

{ #category : #accessing }
SharedPoolsAspect >> fieldName [
	^ #sharedPools
]
