"
I am a role defined by the user in its metamodel.
I include the role #Class 
"
Class {
	#name : #RoleCustom,
	#superclass : #Role,
	#category : #'Espell2-Roles'
}

{ #category : #constants }
RoleCustom >> index2InClassTable [
	^ nil
]

{ #category : #constants }
RoleCustom >> indexInClassTable [
	^ nil
]

{ #category : #constants }
RoleCustom >> indexInSpecialObjectsArray [
	^ nil
]

{ #category : #constants }
RoleCustom >> initialize [
	super initialize.
	self templateClass
		ifNotNil: [ :template | 
			self
				assert: (self modelInstVarNames beginsWith: template modelInstVarNames) ]
]

{ #category : #constants }
RoleCustom >> layoutClass [
	^ self modelClass defaultLayout
]

{ #category : #constants }
RoleCustom >> modelAcceptsExtraInstVars [
	^ false 
]

{ #category : #accessing }
RoleCustom >> modelClass [ 
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

{ #category : #constants }
RoleCustom >> modelInstSpec [
	^ self layoutClass instSpec 
]

{ #category : #constants }
RoleCustom >> modelInstVarNames [ 
	^ self modelClass allClassModelInstVarNames.
]
