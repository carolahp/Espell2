Class {
	#name : #ClassVarAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #accessing }
ClassVarAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #accessing }
ClassVarAspect >> fieldName [
	^ #classPool
]

{ #category : #advices }
ClassVarAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ aClassModel classPool bindingOf: aSymbol
]
