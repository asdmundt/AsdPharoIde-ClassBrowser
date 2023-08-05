Class {
	#name : #ASDPORPackageBasedBrowser,
	#superclass : #WAObject,
	#instVars : [
		'showComment',
		'showInstance',
		'selectedPackage',
		'selectedClass',
		'selectedMessageCategory',
		'dependent',
		'selectedMethod'
	],
	#category : #'AsdPharoIde-ClassBrowser-Model'
}

{ #category : #accessing }
ASDPORPackageBasedBrowser >> addDependent: anObject [
	dependent := anObject
]

{ #category : #private }
ASDPORPackageBasedBrowser >> changed: aParameter [
	dependent isNil ifFalse: [ dependent update: aParameter ]
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> classList [
	^ (self classesInTheSelectedPackage
		collect: [ :each | each name ])
		sorted
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> classListIndex [
	^ (self classesInTheSelectedPackage
		sorted: [ :a :b | a name <= b name ])
		indexOf: selectedClass
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> classListIndex: anInteger [

	selectedClass := (self classesInTheSelectedPackage sorted: [ :a :b | 
			                  a name <= b name ]) at: anInteger.
	self clearMessageAndProtoclSelection.
	self changed: #classListIndex.
	self session selectedClass: selectedClass
]

{ #category : #private }
ASDPORPackageBasedBrowser >> classesInTheSelectedPackage [

	^ selectedPackage
		ifNil:[ #() ]
		ifNotNil:[ selectedPackage classes ]
]

{ #category : #private }
ASDPORPackageBasedBrowser >> clearMessageAndProtoclSelection [
	selectedMethod := nil.
	selectedMessageCategory := nil
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> contents [

	^ showComment
			  ifTrue: [ 
				  self selectedClass isNil ifTrue: [ '' ]
						  ifFalse: [ "class comment" selectedClass organization comment ]
				  ]
			  ifFalse: [ 
				  selectedMethod isNil
						  ifTrue: [ 
							  self selectedClass isNil ifTrue: [ '' ]
									  ifFalse: [ 
										  selectedMessageCategory isNil ifTrue: [ "class definition" 
												  self selectedClass definitionString ]
												  ifFalse: [ "method template" 
												  self selectedClass sourceCodeTemplate ]
										  ]
							  ]
						  ifFalse: [ "method source code" selectedMethod sourceCode ]
				  ]
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> contents: input notifying: aController [
	^ showComment
		ifTrue: [ selectedClass organization comment: input.
			true ]
		ifFalse: [ (self selectedMessageName isNil
				and: [ selectedMessageCategory isNil ])
				ifTrue: [ "compile a class"
					selectedClass subclassDefinerClass new
						source: input;
						logged: true;
						requestor: aController;
						evaluate ]
				ifFalse: [ "compile a method"
					(self selectedClass
						compile: input
						classified: self protocolForSelectedMethod
						notifying: aController) isSymbol ] ]
]

{ #category : #actions }
ASDPORPackageBasedBrowser >> indicateClassMessages [
	showInstance := false.
	showComment := false.
	self clearMessageAndProtoclSelection.
	self changed: #show
]

{ #category : #actions }
ASDPORPackageBasedBrowser >> indicateInstanceMessages [
	showInstance := true.
	showComment := false.
	self clearMessageAndProtoclSelection.
	self changed: #show
]

{ #category : #initialization }
ASDPORPackageBasedBrowser >> initialize [
	super initialize.
	showComment := false.
	showInstance := true
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> messageCategoryList [
	| all categories unclassified |
	all := #'-- all --'. "AllProtocol defaultName is fucked in Pharo 2.0"
	self selectedClass isNil
		ifTrue: [ ^ Array with: all ].
	categories := self selectedClass organization categories.
	(categories notEmpty and: [ categories first = all ]) ifFalse: [ "all is only in 3.0+"
		categories := (Array with: all), categories ].
	unclassified := (Smalltalk at: #Protocol) defaultName. "#unclassified only in 3.0+"
	^ (categories includes: unclassified)
		ifTrue: [
			"'-- all --', 'as yet unclassified', rest sorted alphabetically"
			(Array
				with: categories first
				with: unclassified),
			(categories allButFirst copyWithout: unclassified) sorted ]
		ifFalse: [
			"'-- all --', rest sorted alphabetically"
			(Array with: categories first),
			categories allButFirst sorted ]
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> messageCategoryListIndex [
	^ self messageCategoryList indexOf: selectedMessageCategory
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> messageCategoryListIndex: anInteger [

	selectedMessageCategory := self messageCategoryList at: anInteger.
	selectedMethod := nil.
	self changed: #messageCategoryListIndex.
	self session selectedMessageCategory: selectedMessageCategory
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> messageList [

	^ (selectedMessageCategory isNil
			   ifTrue: [ 
				   self selectedClass isNil ifTrue: [ #(  ) ]
						   ifFalse: [ self selectedClass selectors ]
				   ]
			   ifFalse: [ 
				   | organization organizer |
				   organization := self selectedClass organization.
				   organizer := (organization respondsTo: #protocolOrganizer) 
						                ifTrue: [ organization protocolOrganizer ]
						                ifFalse: [ 
							                | classOrganization |
							                classOrganization := Smalltalk globals class
								                                     name hasClassNamed:
									                                     'ClassOrganization'.
							                (classOrganization fromSpec:
									                 self selectedClass organization)
								                protocolOrganizer
							                ]. "Only in Pharo 3.0+"
				   organizer methodsInProtocolNamed: selectedMessageCategory
				   ]) sorted
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> messageListIndex [
	^ selectedMethod isNil
		ifTrue: [ 0 ]
		ifFalse: [ self messageList indexOf: selectedMethod selector ]
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> messageListIndex: anInteger [

	selectedMethod := self selectedClass
	                  >> (self messageList at: anInteger).
	self changed: #messageListIndex.
	self session selectedMethod: selectedMethod.
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> metaClassIndicated [
	^ showInstance
]

{ #category : #private }
ASDPORPackageBasedBrowser >> packages [
	^ (Smalltalk at: #RPackage) organizer packages
]

{ #category : #private }
ASDPORPackageBasedBrowser >> parentOfClass: aClass [
	"I can answer an RPackage or an RPackageTag, depending on the presence of Tags in package. 
	 This is an UI optimization to not show a tree RPackage->RPackageTag when there is just 
	 one tag in package, named in the same way as his parent"	

	| package tag |
	
	package := aClass package.
	tag := package classTagForClass: aClass.
	
	^ (((tag name = package name) and: [ package classTags size <= 1 ]) or: [ tag isNil ])
		ifTrue: [ package ]
		ifFalse: [ tag ]
]

{ #category : #actions }
ASDPORPackageBasedBrowser >> plusButtonHit [
	showComment := true.
	self clearMessageAndProtoclSelection.
	self changed: #show
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> protocolForSelectedMethod [
	| selectedMessageName |
	selectedMessageName := self selectedMessageName.
	selectedMessageName isNil ifTrue: [ 
		^ selectedMessageCategory ifNil: [ #'-- all --' ] "AllProtocol defaultName is fucked in Pharo 2.0" ].
	^ (self selectedClass >> selectedMessageName asSymbol) category
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> removeDependent: anObject [
	dependent := nil
]

{ #category : #private }
ASDPORPackageBasedBrowser >> selectedClass [

	| class |
	class := selectedClass.
	(class notNil and: [ showInstance not ]) ifTrue: [ 
			class := class classSide ].
	^ class
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> selectedMessageName [
	^ selectedMethod isNil
		ifTrue: [ nil ]
		ifFalse: [ selectedMethod selector ]
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> setClass: aClass selector: aSelector [
	| method protocol |
	method := aClass methodDict at: aSelector ifAbsent: [ nil ].
	protocol := method ifNil: [ nil ] ifNotNil: [ method protocol ].
	selectedPackage := self parentOfClass: aClass.
	selectedClass := aClass.
	showInstance := aClass isMeta not.
	selectedMessageCategory := protocol.
	selectedMethod := method
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> systemCategoryList [
	^ (self packages
		collect: [ :each | each packageName ])
		sorted
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> systemCategoryListIndex [
	^ (self packages
		sorted: [ :a :b | a packageName <= b packageName ])
		indexOf: selectedPackage
]

{ #category : #accessing }
ASDPORPackageBasedBrowser >> systemCategoryListIndex: anInteger [

	selectedPackage := (self packages sorted: [ :a :b | 
			                    a packageName <= b packageName ]) at: anInteger.
	self session selectedPackage: selectedPackage.	
	selectedClass := nil.
	self clearMessageAndProtoclSelection.
	self changed: #systemCategoryListIndex
]
