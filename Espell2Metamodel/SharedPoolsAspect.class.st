Class {
	#name : #SharedPoolsAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #accessing }
SharedPoolsAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #accessing }
SharedPoolsAspect >> fieldName [
	^ #mySharedPools
]

{ #category : #advices }
SharedPoolsAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ aClassModel mySharedPools bindingOf: aSymbol
]
