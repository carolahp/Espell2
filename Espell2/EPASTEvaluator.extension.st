Extension { #name : #EPASTEvaluator }

{ #category : #'*Espell2' }
EPASTEvaluator >> contextFrom: aDASTContext [
	^ self objectSpace backend contextFrom: aDASTContext
]
