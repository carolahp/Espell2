Class {
	#name : #MatchDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModel [
	| model aspectCV membrane pc |
	
	model := self newModel.
]

{ #category : #'as yet unclassified' }
MatchDemo class >> newModel [
	^ MatchLanguage
		newFromModel: '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin' asFileReference
		withName: 'Match'
		withEntryPoint: 'System log: ''match!''.
		System quit'.
]
