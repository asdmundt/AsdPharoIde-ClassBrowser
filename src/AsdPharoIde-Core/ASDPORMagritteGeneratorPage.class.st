Class {
	#name : #ASDPORMagritteGeneratorPage,
	#superclass : #ASDPORPageModules,
	#category : #'AsdPharoIde-Core-Web'
}

{ #category : #accessing }
ASDPORMagritteGeneratorPage class >> pageName [
	^ 'Magritte Genarator'
]

{ #category : #accessing }
ASDPORMagritteGeneratorPage class >> priority [
	^ 3
]

{ #category : #initialize }
ASDPORMagritteGeneratorPage >> initialize [
	super initialize.

	
]

{ #category : #rendering }
ASDPORMagritteGeneratorPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [  ] ]
]
