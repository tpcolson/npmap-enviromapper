<template>
	<div class='box' style="border: none;">
		<div class='label'>1. Select an environmental attribute</div>   
        <multiselect
              v-model="selected"
              :options="layersArray"
              placeholder="Select an environment layer"
              @input="layerChanged"
              label="label"
              track-by="label"
              :showLabels="false"
            ></multiselect>
		<InfoBox :layers="layersForSubCat"></InfoBox>
	</div>
</template>

<script>
import InfoBox from './InfoBox.vue';

export default {
    name: 'EnvironmentsBox',
    components: {
      InfoBox
    },
    data: function(){
        return {
            layersArray: [],
            layersObject: {},
            selected: "",
            layersForSubCat: {}
        }
    },
    methods: {
        layerChanged: function(){
            let selected; 
            for (let key in this.layersArray) { 
                if (this.layersArray[key].name == this.$data.selected.name) { 
                    selected = key; 
                    break;
                } 
            }
            for (let key in this.$data.layersObject) {
                if (this.$data.layersArray[selected].name == this.$data.layersObject[key].name) {
                    this.layersForSubCat = this.$data.layersArray[selected];
                    this.$root.$emit('layerChanged', this.$data.layersArray[selected], 
                        key);
                    break;
                }
            }
            
        }
    },
    mounted: function()
    {
        var self = this;
        $.ajax({
            url: 'data.json',
            method: 'GET',
            success: function(data)
            {
                self.layersArray = Object.values(data);
                self.layersObject = data;
                for (let key in self.layersArray) { 
                    let layer = self.layersArray[key]; 
                    if (layer.subcategories.length > 0 || layer.type == 'continuous') { 
                        self.layersArray[key].label = layer.name;
                    } 
                    if (layer.subcategories.length == 0 && layer.type == 'categorical') { 
                        self.layersArray[key].label = '-' + layer.name;
                    }
                }
            }
      });
    }
}
</script>
<style>
.box{
    
}
</style>
