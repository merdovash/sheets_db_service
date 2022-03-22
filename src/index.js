'use strict';

const e = React.createElement;
const noPhoto = 'https://farkop32.ru/wp-content/uploads/2019/04/empty-avatar.png';


class Person extends React.Component {
    constructor(props) {
    super(props);
    this.state = {
        info: props.info,
        wikipedia_page: props.info.wikipedia_page || null,
        loading: !props.info.wikipedia_page,
    };
  }

  async componentDidMount() {
    if (this.state.loading) {
        const url = '/wikipedia/'+this.state.info.name;
        const response = await fetch(url);
        const data = await response.json();
        console.log(data);
        this.setState({
            loading: false,
            wikipedia_page: data,
        })
    }
  }


  render() {
    return (
        <MaterialUI.Card className="itemContainer">
          <MaterialUI.CardHeader
            title={this.state.info.name}
          />
          <MaterialUI.CardMedia
            component="img"
            width="300px"
            image={this.state.info.photo || noPhoto}
            alt={this.state.info.name}
          />
          <MaterialUI.CardContent>
            <MaterialUI.Typography variant="body2" color="text.secondary">
              {this.state.info.description || 'нет описания'}
            </MaterialUI.Typography>
          </MaterialUI.CardContent>
          <MaterialUI.CardActions>
          <MaterialUI.Typography variant="body2" color="text.secondary">
            Заслуги
          </MaterialUI.Typography>
            { 
              [
                this.state.info.link && (
                  <MaterialUI.Button href={this.state.info.link}>
                    {
                      this.state.info.link.includes('twitter') ? 'Twitter' : this.state.info.link.includes('youtube') ? 'Youtube' : this.state.info.link.includes('instagram') ? 'Instagram': this.state.info.link
                    }
                  </MaterialUI.Button>
                ),

                this.state.wikipedia_page && (
                  <MaterialUI.Button href={this.state.wikipedia_page}>
                    wikipedia
                  </MaterialUI.Button>
                )
                    
              ]
            }
          </MaterialUI.CardActions>
        </MaterialUI.Card >
    )
  }
}


class LikeButton extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        loading: true,
        persons: null
    };
  }

  async componentDidMount() {
    if (this.state.loading) {
        const url = '/data';
        const response = await fetch(url);
        const data = await response.json();
        console.log(data);
        this.setState({
            loading: false,
            persons: data,
        })
    }
  }

  render() {
    if (this.state.loading) {
      return (
        <MaterialUI.CircularProgress />
      );
  } else {
      return (
        <MaterialUI.Container maxWidth="lg">
          <MaterialUI.Grid container spacing={2}>
              {this.state.persons.map((el) => {
                  return <MaterialUI.Grid item><Person info={el} key={el.id}/></MaterialUI.Grid>
              })}
          </MaterialUI.Grid>
        </MaterialUI.Container>
      );
    }
  }
}

const domContainer = document.querySelector('#root_container');
ReactDOM.render(e(LikeButton), domContainer);