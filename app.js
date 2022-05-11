import express from "express";

const app = express();

app.get('/', (req, res) => {
    res.send("haha 😂")
});

app.listen(3000, () => {
    console.log("💚️server is running")
});