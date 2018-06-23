<template>
    <div>
        <div class="label environment-info">
            {{ mutableInfo }} 
        </div>

        <span style="display: block;" v-if="subcatName1 != '' || subcatName2 != ''">
            <transition name="info-slide">
            <div v-if="open" class="species-info-box">
                <div class="info-box-title">{{ subcatName1 }}</div>
                <div style="" class="info-box-image environment-image"><img src="http://via.placeholder.com/150x150" /></div>  
                <div class="info-box-info">
                    Here is some information about this subcategory. For example, where it encompasses, how important it is to species in general, etc. 
                </div>
            </div>
            </transition>
            <div @click="open=!open" class="species-info-toggle" style="margin-left: 200px; margin-top: 0px;">
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
        open: false,
        layer: {
            type: Object
        }
    },
    data: function() {
        return {
            mutableInfo: this.info,
            subcatName1: {
                default: '',
                type: String
            },
            subcatName2: {
                default: '',
                type: String
            }
        }
    },
    mounted: function(){
        this.$root.$on('layerChanged', data =>{
//            console.log(data.info);
//            console.log(data);
//            console.log(this.layer);
            this.mutableInfo = data.info;
        });
        this.$root.$on('subcatChanged', (subcatName, subcatNumber) => {
            let name = subcatName;
            if (subcatNumber == 1) {
                if (subcatName == 'null') {
                    name = '';
                }
                this.subcatName1 = name;
            }
            if (subcatNumber == 2) {
                if (subcatName == 'null') {
                    name = '';
                }
                this.subcatName2 = name;
            }
        });
    },
    watch: {
        info: function() {
            this.mutableInfo = this.info;
        }
    }
}
</script>

<style>
.info-box-title {
    font-weight: bold;
    border-bottom: 5px solid magenta;
    width: 100px;
    padding: 10px;
    margin-bottom: 10px;
}
.info-box-image {
    text-align: center;
}
.species-info-box {
    background-color: #EAEAEA;
    width: 470px; 
    height: 300px;
    position: relative; 
    z-index: 10000;
    color: #333;
    box-shadow: 0 0 5px #777, inset 0 6px 3px -5px #777;
    border: 1px solid #999;
    border-top: 0;
}
.info-slide-enter {
    height: 0;
}
.info-slide-enter-to {
    transition: height .5s ease-out;
    height: 300px;
}
.info-slide-leave-to {
    height: 0;
    transition: height .5s ease-out;
}
</style>
