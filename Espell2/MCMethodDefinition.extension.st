Extension { #name : #MCMethodDefinition }

{ #category : #'*Espell2' }
MCMethodDefinition >> ensureEspellDefinitionIn: anEP2MLanguage [ 
	^ anEP2MLanguage addMethodFromMonticelloDefinition: self
]

{ #category : #'*Espell2' }
MCMethodDefinition >> ensureEspellDefinitionIn: anEP2MLanguage package: anEP2MPackage [ 
	| def  |
	def := self ensureEspellDefinitionIn: anEP2MLanguage.
	"def package: anEP2MPackage."
	^ def

]
