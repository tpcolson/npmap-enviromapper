<template>
	<div class='box' style="border: none;">
		<div class='label'>Select an environmental attribute to view affected species</div>
		<select v-model="selected" v-on:change="layerChanged">
			<option value="" disabled selected>Select an environment layer</option>
			<option v-for="(item, key, index) in layers">
				{{ key }}
			</option>
		</select>      
		<InfoBox></InfoBox>
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
            layers: {}, 
            selected: ""
        }
    },
    methods: {
        layerChanged: function(){
            this.$root.$emit('layerChanged', this.$data.layers[this.$data.selected]);
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
                self.layers = (data);
            }
        });
    }
}
</script>
