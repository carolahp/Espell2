Class {
	#name : #ClassVarAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #accessing }
ClassVarAspect >> adviceInnerBindingOf [
	^ PhAdvice new
		pointcut: self pcInnerBindingOf;
		advice: [ :context | 
			| model varName |
			(context dynamicContext).
			model := context receiver.
			varName := (context arguments at: 1) asSymbol.
			model classPool bindingOf: varName];
		type: #around
]

{ #category : #accessing }
ClassVarAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #accessing }
ClassVarAspect >> fieldName [
	^ #classPool
]
