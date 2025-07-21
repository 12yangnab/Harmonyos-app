const DRAFT_WIDTH=360;

export default  function rvp(val:number){


    return val/DRAFT_WIDTH*(AppStorage.get('windowWidth') as number);
}