Class {
	#name : #SharedPoolsAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #accessing }
SharedPoolsAspect >> fieldName [
	^ #mySharedPools
]

{ #category : #accessing }
SharedPoolsAspect >> fieldValueFor: aClassModel [
	^ Dictionary new
]

{ #category : #advices }
SharedPoolsAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ aClassModel mySharedPools bindingOf: aSymbol
]
