Class {
	#name : #Role,
	#superclass : #Object,
	#instVars : [
		'name',
		'language'
	],
	#category : #'Espell2-Roles'
}

{ #category : #'as yet unclassified' }
Role class >> defaultClassRoles [
	" get roles from EP2Remote subclasses"
	| templates |
	templates := (EP2Remote allSubclasses add: EP2Remote; yourself).
	^ ((templates select: [ :each | each role isNotNil ])
		collect: [ :each | each role asSymbol -> each role asSymbol ])
		asDictionary
]

{ #category : #'as yet unclassified' }
Role class >> named: aString for: aLanguageModel [
	^ self basicNew
		name: aString;
		language: aLanguageModel;
		initialize;
		yourself
]

{ #category : #constants }
Role >> index2InClassTable [
	^ self templateClass index2InClassTable 
]

{ #category : #constants }
Role >> indexInClassTable [
	^ self templateClass indexInClassTable 
]

{ #category : #constants }
Role >> indexInSpecialObjectsArray [
	^ self templateClass indexInSpecialObjectsArray 
]

{ #category : #testing }
Role >> isImmediate [ 
	^ language immediateClassRoles anySatisfy: [:rol | rol = name ]
]

{ #category : #accesssing }
Role >> language: anObjVLispMinLanguage [ 
	language := anObjVLispMinLanguage
]

{ #category : #accessing }
Role >> layoutClass [ 
	^ self templateClass layoutClass
]

{ #category : #testing }
Role >> modelAcceptsExtraInstVars [
	^ self templateClass modelAcceptsExtraInstVars 
]

{ #category : #accessing }
Role >> modelClass [ 
	| metamodels result |
	metamodels := ({language class classModel} asOrderedCollection
		addAll: (language allClasses values collect: #class);
		yourself) asSet.
	result := (metamodels
		select: [ :aMetamodel | aMetamodel role = name ]) ifEmpty: [^ nil].
	
	self
		assert: result size = 1
		description: 'role "' , name , '" defined by more than one ObjectModel class'.
	
	^ result anyOne
]

{ #category : #'as yet unclassified' }
Role >> modelInstSpec [
	^ self templateClass modelInstSpec 
]

{ #category : #accessing }
Role >> modelInstVarNames [
	self modelClass
		ifNotNil: [ :found | ^ found allClassModelInstVarNames ].
	^ self templateClass modelInstVarNames 
]

{ #category : #accessing }
Role >> name [ 
	^ name
]

{ #category : #accessing }
Role >> name: aString [ 
	name := aString
]

{ #category : #accessing }
Role >> templateClass [ 
	| result |
	result := EP2Remote allSubclasses
		select: [ :aTemplate | aTemplate role = name ].
	result ifEmpty: [ ^ nil ].
	self
		assert: result size = 1
		description: 'role "' , name , '" defined by more than one EP2Remote subclass'.
	
	^ result anyOne
]
