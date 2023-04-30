export default {
    components: {
        
    },
    props: {
      appstate: {},
    },
    data() {
      return {
        
      };
    },
    created(){
          
    },
    mounted(){
      console.log(this.appstate);
    },
    methods: {
      updateSuggestions(){
      
      },
      formSubmit(type){
        console.log('formSubmit');
        if (type == 'add-product'){
          console.log(this.pending);
          console.log(this.pending.productAdd);
        
          $.ajax({ //TODO
                url: this.env['API_URL'],
                type: 'POST',
                data: '',
                processData: false,
                contentType: false,
                success: (res) => { 
                },
                error: function(info){
                    console.log(info);
                }
            });
        }
  
  
      }
    }
  }