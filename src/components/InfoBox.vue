<template>
    <div>
        <div class="label environment-info">
            {{ info }} 
        </div>

        <span style="margin-top: 66px; display: block;">
            <transition name="info-slide">
            <div v-if="open" class="species-info-box">
                <div style="" class="info-box-image environment-image"></div>  
                <div class="info-box-info">
                    Here is some information about this environment layer. For example, where it encompasses, what categories does it have, how important it is to species in general, etc. 
                </div>
            </div>
            </transition>
            <div @click="open=!open" class="species-info-toggle" style="margin-left: 80px; margin-top: 0px;">
                <div class="triangle"></div>
            </div>
        </span>
    </div>
</template>
<script>
export default {
    name: "InfoBox",
    props: {
        info:{
            default: "",
            type: String
        },
        open: false
    },
    mounted: function(){
        this.$root.$on('layerChanged', data =>{
            console.log(data.info);
            this.info= data.info;
        });
    }
}
</script>

<style>
.species-info-box{
    background-color: #EAEAEA;
    width: 400px; 
    height: 300px;
    position: relative; 
    z-index: 10000;
    color: #333;
    box-shadow: 0 0 5px #777, inset 0 6px 3px -5px #777;
    border: 1px solid #999;
    border-top: 0;
}
.info-slide-enter{
    height: 0;
}
.info-slide-enter-to{
    transition: height .5s ease-out;
    height: 300px;
}
.info-slide-leave-to{
    height: 0;
    transition: height .5s ease-out;
}
</style>
