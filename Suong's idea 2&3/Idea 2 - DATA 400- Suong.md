# Developing a Hazard Identification Tool for Chemical Ingredients
## _Suong Tran_
----------
### Introduction
Nowadays, consumers are increasingly concerned about what hidden ingredients products may contain. We worry not only for our own well-being, but also the health of our pets and the planet we all call home. However, navigating the alphabet soup of chemical names is daunting. There has to be a better way to decrypt this mystery for the everyday person just trying to make good choices. 

To help consumers reading the "ingredient table", I hope to developing a straightforward resource to decode chemical risk levels so that it could provide consumers with essential information about the chemicals present in products. By simplifying the process of understanding chemical hazards, this tool has the potential to revolutionize consumer decision-making. It empowers individuals to make choices aligned with their values of health and sustainability. Moreover, it fosters a culture of responsible consumption, where consumers are empowered to prioritize products that uphold their well-being and that of the environment. Ultimately, I believe that this tool will play a pivotal role in safeguarding public health and the environment. By raising awareness of potential hazards, educating consumers, and driving industry innovation towards safer alternatives, it has the power to effect positive change on a global scale. Together, we can navigate the complexities of chemical ingredients and pave the way towards a healthier, more sustainable future for all.

***The output of this project is expected to be a user-friendly dashboard which takes consumers' picture of the "ingredient table" then provides consumers with easy-to-read hazard information of the chemical ingredients in products.***

### Data

The OpenFoodTox database provided by The European Food Safety Authority (EFSA) will be used in this project.

> OpenFoodTox is a structured database summarising the outcomes of hazard identification and characterisation for the human health (all regulated products and contaminants), the animal health (feed additives, pesticides and contaminants) and the environment (feed additives and pesticides). 

### Methodology

- **SQL** can be used for querying and managing the database.
- **Data visualization + Interactive dashboard:** Using web development frameworks such as Django (Python) or Express (Node.js), a user-friendly interface will be created where users can upload images, view extracted text, and explore hazard data. 
- **Extracting text from image:** This process involves preprocessing the images, detecting text regions. I plan to use *pytesseract* Optical Character Recognition (OCR).
