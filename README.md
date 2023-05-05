<p align="center"><img src="Gekko_logo.png" style="display:block; margin:auto; width:400px"></p>
<h1 size=7 align="center">Gekko 0.0.1</h1>
<h4 align="center">Modular User Interface System for GameMaker 2.3+</h4>
<hr>



<p align="center"><img src="https://user-images.githubusercontent.com/54528582/236492942-924265f9-461c-417e-8946-6192f0f26b74.png" style="display:block; margin:auto; width:180px; margin-bottom: -46px;"></p>
<h3 align="center">
  <p align="center">
  The library and the readme is currently under construction, feel free to check out Gekko if you want to.
I'm currently building and fleshing out functionality :)</p>

<p align="center">
  You can <a href="https://github.com/JustFredrik/Gekko/releases"> download the .yymps</a> to get started</p>
If you are interested to learn more, ask questions or give feedback please join the <a href="https://discord.com/invite/47ap8cE"> Discord</a>! 
 </h3>


<hr>
<br>


<p align="justify">
  The Gekko library is a versatile and user-friendly UI toolkit for GameMaker 2.3+, designed to streamline the creation of graphical user interfaces in your projects. Built around the concept of components, Gekko supports various visual elements and offers automatic synchronization, anchoring, and event handling capabilities. Tailored for developers of all skill levels, Gekko empowers you to build interactive and responsive UI elements with ease.</p>




<br>
<img align="right" src="https://user-images.githubusercontent.com/54528582/236459900-635fdb5d-aa4f-4ef3-a30c-9ebaefb4746b.png" style="display:block; margin:auto; width:400px">
<h2>The Gekko Component System</h2>
<p align="justify">
  The Gekko library is built around the concept of components, which are the fundamental elements used to create graphical user interfaces (GUI) in Gekko. Components can represent various visual elements such as text, sprites, nine-slices, and lists, and can be nested and used to create intricate GUI designs.</p>

<p align="justify">
  To ensure that components maintain their relative positions on the screen regardless of the game's aspect ratio, they can be anchored to specific parts of the screen. Furthermore, Gekko offers global re-scaling capabilities to automatically fit the user interface to the screen, ensuring a uniform appearance across various resolutions. This allows for a consistent layout across various devices and display settings.</p>

<p align="justify">
  Components also offer the ability to link their properties, such as position and scale, to variables from other structs or instances, enabling automatic synchronization. Additionally, you can define custom callbacks for specific property changes, allowing components to perform actions like shaking when the health decreases or scaling up as health increases.</p>

<p align="justify">
  Gekko takes care of mouse hovering detection automatically, and it also provides the option to specify custom callbacks for events like clicking on a component. This makes it easy for developers to create interactive and responsive UI elements within their GameMaker projects.</p>
<br>
<hr>
<br>

<img align="left" src="https://user-images.githubusercontent.com/54528582/236490560-87b23ec3-db91-4fd1-bc8d-b7802020d303.png" style="display:block; margin:auto; width:300px">
<h2>Animated Properties</h2>
<p align="justify">
Gekko offers seamless animation support for component properties, simplifying the process of creating dynamic UI elements. By utilizing the component.set_default_animation_style() function, developers can choose from instant, linear, or spring-based animations for various component properties. This enables effortless animation of attributes like position (x, y), scale, separation, and many more.</p>

<p align="justify">
Looking to create a responsive, bouncy button with a touch of 'juice'? Simply set the button's scale to increase upon triggering the hover event, and you'll have an engaging, interactive button with just a few lines of code!</p>





