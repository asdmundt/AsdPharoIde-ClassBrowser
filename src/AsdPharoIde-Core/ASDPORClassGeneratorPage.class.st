Class {
	#name : #ASDPORClassGeneratorPage,
	#superclass : #ASDPORPageModules,
	#category : #'AsdPharoIde-Core-Web'
}

{ #category : #accessing }
ASDPORClassGeneratorPage class >> pageName [
	^ 'Magritte Genarator'
]

{ #category : #accessing }
ASDPORClassGeneratorPage class >> priority [
	^ 3
]

{ #category : #initialize }
ASDPORClassGeneratorPage >> initialize [
	super initialize.

	
]

{ #category : #rendering }
ASDPORClassGeneratorPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [  ] ]
]
