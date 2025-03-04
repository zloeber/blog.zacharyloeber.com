```prompt
Create a narrative based pitch for a mobile application that creates on-demand escape room scenarios for its users. The application employs the latest AI technology to analyse surroundings and creates customized experiences catered to the user's input. The user will be prompted for target player age range, count, challenge level, number of challenges, approximate time to complete, and preparation complexity. This application will generate a walkthrough for the preparer that can be followed to setup the game along with a list of required supplies.
```

**Introducing EscapeGenie: Unleashing the Ultimate On-Demand Escape Room Experience**

Imagine being transported to a new world, where the ordinary becomes extraordinary, and the clock is ticking. Welcome to EscapeGenie, the revolutionary mobile application that brings the thrill of escape rooms to your doorstep, tailored to the passions of board game enthusiasts but is still easy enough to be used by non-gamers alike. With the power of AI at its core, EscapeGenie crafts customized escape room scenarios that cater to your every whim, ensuring an unforgettable adventure for you and your fellow gamers.

**How it Works**

Simply launch the app, and EscapeGenie's AI will guide you through a brief setup process. Select the the number and age of players, challenge level, and approximate time to complete. You will then choose the number of challenges and preparation complexity to suit your preferences and the supplies you have on hand (paper, scissors, lock/key, et cetera). Finally, you will be prompted to take photos of the room or rooms you wish to have the adventure span across. This information will be magically weaved into a unique escape room scenario, tailored to your surroundings. Easily followed preparation instructions will be created for you to follow to create the puzzles and setup the rooms for play.

EscapeGenie becomes the puzzle master host by setting the stage with an engaging preface story and goal for your players that gets spoken out loud. Then the game starts! 

Each solved puzzle be input into your device as they are solved to keep tabs on progress and allow for tips to be requested if the players are stuck. The application can read all this out loud. Optionally, there will be theme appropriate music, timers, and puzzle elements.

**The Preparation**

Once you've input your preferences, EscapeGenie generates a comprehensive walkthrough for the preparer, complete with a detailed list of required supplies. This ensures a seamless setup process, allowing you to focus on the excitement to come. The walkthrough is complete with tips and suggestions to enhance the overall experience, making you the master of ceremonies.

**The Experience**

As the game begins, the app will guide players through a series of challenges and puzzles, expertly designed to match your selected preferences. The AI-powered gameplay ensures that each obstacle is tailored to the players' progress, providing an optimal level of difficulty and engagement. The countdown timer adds an extra layer of suspense, as players rush to solve the final puzzle and escape the simulated world.

**Key Features**

- **AI-driven scenario generation**: Ensures a unique experience with every play through
- **Customized Play**: Adjust everything to make the experience your own including;
	- Difficulty
	- Player age range
	- Approximate play time
	- Preparation effort
	- Theme
	- Number of players
	- And more!
- **Comprehensive setup guide**: Makes preparation a breeze, even for the most intricate scenarios
- **Real-time feedback**: The app adjusts challenge difficulty on the fly, guaranteeing an optimal experience

## Game Modes
EscapeGenie offers multiple modes that allow for non-makers and do it yourself pros alike to make compelling escape room scenarios including;
- **Creator (advanced)**: For the makers out there. You will follow directions to setup the room and create required props and effects to enhance the experience.
- **Attendant (novice)**: EscapeGenie acts like an escape room attendant  moderates the experience while players work on solving puzzles together.
- **Guided (default):** Prevent your room from getting torn apart looking for clues using this mode to lay a trail of breadcrumbs from one puzzle to the next.
- **On-Demand (pro):** The current room is used to create a single puzzle using augmented reality and your camera.

**Join the EscapeGenie Community**

By downloading EscapeGenie, you'll not only gain access to a library of dynamic escape room scenarios but also become part of a vibrant community of board game enthusiasts and players. Share your own custom scenarios, browse user-generated content, and participate in forums to discuss the latest escape room trends and board game adaptations.

**Unlock the Magic**

EscapeGenie is the perfect solution for:

- Board game groups seeking new challenges
- Social gatherings with a competitive twist
- Team-building exercises for gaming communities
- Parents looking for ways to extract their children from the clutches of mindless screen time
- Educational institutions seeking interactive learning tools for game design and development

**Download EscapeGenie today** and discover the thrill of on-demand escape rooms. Get ready to unlock the magic and unleash the adventure!

```prompt

The main application will consist of the user being prompted one question at a time customization questions for their escape room experience. Each question will have a back and forward button and a start over option. The questions will be configured using a jsonschema validated json file and will contain the following questions; 
2. How long should the experience take? (5-10 min, 10-20 minutes, "Buy pro to unlock longer experiences!")
3. What is the age range of your escape room participants? (6-10, 10-20, "Buy pro to unlock custom age ranges!")
4. How many escape room participants? (1-2, 1-4, "Buy pro to unlock more participants!")
5. How much effort do you willing to spend preparing? (Little to  none, Some effort,  "Buy pro to unlock more complex preparations!") 
6. How would you like to scan the room? (Camera/Photo Upload,  "Buy pro to unlock more methods!")
In all questions the last option to buy the pro version is not in the drop down but rather is the example description shown in the drop-down box before it has been clicked on.

After answering these questions and saving the results locally the user is then brought to the interactive room scanning part of the application. As "Camera/Photo Upload" is the only option currently the user will be prompted four times to take a picture of one of the 4 sides of the room (with the option to also upload a photo). Remind the user to use good light and stand as far back as possible to capture as much detail as possible. After each photo taken or uploaded the user will be shown the picture and be given a simple editing interface that will allow them to put bright red borders around the focus area and black boxes around ignored areas. Each photo should then be saved with the boundary and blackouts as the final image.
```

---
## Bootstrap Development

```prompt
A typescript react native cross platform mobile application that includes local litesql state management. Include github actions that will build and package the application for deployment into the google and Apple stores. Include a Taskfile.yaml definition that includes all build and deploy tasks. Additionally add a mise.toml file with default node and task application versions.
```