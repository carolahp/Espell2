Class {
	#name : #ClassVarAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #constants }
ClassVarAspect >> defaultFieldValue [
	^ Dictionary new
]

{ #category : #constants }
ClassVarAspect >> fieldName [
	^ #classPool
]
