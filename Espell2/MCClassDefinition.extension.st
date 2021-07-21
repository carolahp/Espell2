Extension { #name : #MCClassDefinition }

{ #category : #'*Espell2' }
MCClassDefinition >> ensureEspellDefinitionIn: aLanguageModel [ 
	
	^ aLanguageModel addBehaviorFromMonticelloDefinition: self
]

{ #category : #'*Espell2' }
MCClassDefinition >> ensureEspellDefinitionIn: aEP2MLanguage package: anEP2MPackage [ 
	| def |
	def := self ensureEspellDefinitionIn: aEP2MLanguage.
	def package: anEP2MPackage.
	"def category: def tags first."
	^ def
]
