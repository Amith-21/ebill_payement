# EB Billing System 💡

Hey! This is my project for managing electricity bills online. I built this as part of my coursework/learning React and web development.

## What is this? 

So basically, this is a web application where people can:
- Pay their electricity bills online (super easy!)
- Check their past bills and payment history
- Calculate their bills before they get them
- View their meter readings
- Apply for new connections online
- Update their account information

It's like a digital platform for electricity bill management. I thought it would be useful because everyone has to pay electricity bills, right? 

## Features 

- **Easy Login**: You can login with OTP or password (I added both options)
- **Bill Payment**: Pay bills securely (well, it's stored in localStorage for now, but it works!)
- **Bill Calculator**: Calculate how much your bill will be before it arrives
- **Payment History**: See all your past payments in one place
- **Meter Readings**: View your electricity consumption readings
- **Apply Online**: Apply for new electricity connections
- **Update Info**: Change your account details anytime

## Tech Stack 

I used these technologies to build this:

- **React** - For the frontend (I'm still learning this but it's cool!)
- **TypeScript** - Makes coding less error-prone (my teacher said to use it)
- **Vite** - Super fast build tool (way better than create-react-app)
- **Tailwind CSS** - For styling (no more writing separate CSS files!)
- **React Router** - For navigation between pages
- **shadcn/ui** - Pre-built components that look professional
- **Lucide React** - For icons (they look nice)

## How to Run This Project 

Okay so here's how you can run this on your computer:

### Prerequisites
Make sure you have Node.js installed. If you don't, download it from [nodejs.org](https://nodejs.org/)

### Steps:

1. **Clone this repository** (or download the zip file)
   ```bash
   git clone <repository-url>
   cd electrify-my-bills-main
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```
   (This might take a few minutes, grab a coffee ☕)

3. **Start the development server**
   ```bash
   npm run dev
   ```

4. **Open your browser**
   - It should automatically open, or go to `http://localhost:5173`
   - You should see the homepage!

## Project Structure 

```
src/
├── components/     # Reusable components (Navbar, buttons, etc.)
├── pages/         # Different pages of the app (Login, Dashboard, etc.)
├── hooks/         # Custom React hooks
├── lib/           # Utility functions
└── main.tsx       # Entry point
```

## Screenshots 

(I should add screenshots here but I haven't taken them yet )

## What I Learned 

- How to use React Router for navigation
- Building forms with validation
- Using Tailwind CSS for responsive design
- Working with React hooks (useState, useEffect, etc.)
- Creating a multi-page application
- Managing state with localStorage (for now)

## Known Issues / Things to Improve 

- Data is stored in localStorage (not a real database) - I know this isn't production-ready but it works for the project!
- No backend yet (maybe I'll add it later if I have time)
- Some features might have bugs (I'm still learning!)
- The design could be better (but I tried my best!)

## Future Improvements 

If I have more time, I'd like to:
- Add a proper backend with a database
- Add real payment gateway integration
- Add email notifications
- Make it more responsive for mobile
- Add more features like bill reminders

## Credits 

- Icons from [Lucide](https://lucide.dev/)
- UI components from [shadcn/ui](https://ui.shadcn.com/)
- Learned a lot from YouTube tutorials and documentation

## License 

This is just a student project, so feel free to use it for learning purposes!

---

**Note**: This is a learning project, so don't use it for actual bill payments! 

If you find any bugs or have suggestions, feel free to let me know!

Made with  (and a lot of coffee )
