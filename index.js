const app = require("express");
const cliente = require("redis");

const app = express();
const cliente = createClient({
   host: 'redis-server',
   port: 6379
});

cliente.set('visits', 0);

app.get('/', (req, res) => {
   cliente.get('visits', (err, visits) => {
      visits = parseInt(visits) + 1;
      res.send(`Number of visits is: ${visits}` );
      cliente.set("visits", parseInt(visits))
   });
});

app.listen(8081, () => {
   console.log('Serviço na porta 8081');
});
