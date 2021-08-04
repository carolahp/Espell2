Class {
	#name : #Role,
	#superclass : #Object,
	#instVars : [
		'name',
		'language'
	],
	#category : #'Espell2-Roles'
}

{ #category : #constants }
Role class >> defaultClassRoles [
	" get roles from EP2Remote subclasses"
	| templates |
	templates := (EP2Remote allSubclasses add: EP2Remote; yourself).
	^ ((templates select: [ :each | each role isNotNil and: [each role ~= #Class ]])
		collect: [ :each | each role asSymbol -> each role asSymbol ])
		asDictionary
]

{ #category : #instantiation }
Role class >> named: aString for: aLanguageModel [
	| roleClass |
	roleClass := (self defaultClassRoles includes: aString)
		ifTrue: [ Role ]
		ifFalse: [RoleCustom].
	^ roleClass basicNew
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

{ #category : #constants }
Role >> modelInstSpec [
	^ self templateClass modelInstSpec 
]

{ #category : #accessing }
Role >> modelInstVarNames [
	
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

{ #category : #tests }
Role >> test: aClassModel [
	self testFormat: aClassModel.
	self testInstanceVariables: aClassModel.
]

{ #category : #tests }
Role >> testFormat: aClassModel [
	| modelInstSpec correctInstSpec |
	modelInstSpec := aClassModel instSpec.
	correctInstSpec := self modelInstSpec.
	self
		assert:
			(modelInstSpec = correctInstSpec
				or: (correctInstSpec = 1 and: modelInstSpec = 0))
		description:
			'Wrong instSpec in class "' , aClassModel name , '" (role "'
				, self name , '"). It should be ' , correctInstSpec asString
				, ' but it is ' , modelInstSpec asString.
	self
		assert: self modelInstVarNames size <= aClassModel instSize
		description:
			'Number of instance variables in class "' , aClassModel name
				, '" (role "' , self name , '"). do not match its instSize value'
]

{ #category : #tests }
Role >> testInstanceVariables: aClassModel [
	| modelInstVars roleInstVars |
	roleInstVars := self modelInstVarNames.
	roleInstVars
		doWithIndex: [ :ivName :index | 
			self
				assert: (aClassModel instVarIndexFor: ivName ifAbsent: [ 0 ]) = index
				description:
					'Instance variable "' , ivName , '" should be in position '
						, index asString , ' in class ' , aClassModel name , ' (role "'
						, self name , '") ' ].
	self modelAcceptsExtraInstVars
		ifTrue: [ ^ self ].
	modelInstVars := aClassModel allInstVarNames.
	self
		assert: modelInstVars size = roleInstVars size
		description:
			self name , ' should define the next inst vars exactly '
				, roleInstVars asString
]
