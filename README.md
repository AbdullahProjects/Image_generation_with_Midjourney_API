# AI Image Generator

A simple one-page Flutter app that allows users to generate images using the MidJourney AI model API. Users can input a prompt, negative prompt, aspect ratio, and art style, then click the **"Generate Now"** button to create an AI-generated image.

## Features
- Enter a **prompt** to describe the image
- Add a **negative prompt** to avoid unwanted elements
- Select an **aspect ratio**
- Choose an **art style**
- Generate high-quality AI images using **MidJourney API**

## Screenshots

### Demo Images
| Generated Image 1 | Generated Image 2 | Generated Image 3 |
|------------------|------------------|------------------|
| ![Image 1](https://github.com/AbdullahProjects/Image_generation_with_Midjourney_API/blob/main/assets/images/Screenshot%202025-02-08%20185655.png) | ![Image 2](https://github.com/AbdullahProjects/Image_generation_with_Midjourney_API/blob/main/assets/images/Screenshot%202025-02-08%20185718.png) | ![Image 3]([demo/demo3.png](https://github.com/AbdullahProjects/Image_generation_with_Midjourney_API/blob/main/assets/images/Screenshot%202025-02-08%20185729.png)) |

## Tech Stack
- **Flutter** & **Dart** for the front-end
- **MidJourney API** for image generation

## Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/ai-image-generator.git
   ```
2. Navigate to the project folder:
   ```bash
   cd ai-image-generator
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## API Setup
Make sure to add your MidJourney API key in the project:
```dart
const String apiKey = "YOUR_API_KEY";
```

## Contributing
Feel free to fork this project and submit pull requests!
