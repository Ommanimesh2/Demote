import React, { useEffect } from 'react'
import { getAuth, signInWithPopup, GoogleAuthProvider} from 'firebase/auth'
import './firebase'
const provider= new GoogleAuthProvider()
    // const auth= getAuth()
const SignIn = () => {
    const auth= getAuth()
    function SignInWithGoogle(){
        signInWithPopup(auth,provider).then((e)=>{
            if(window != undefined){

                const { displayName, email, photoURL, uid } = e.user
                const data={
                    displayName,email,photoURL,uid
                }
                window.location.href= 'electron-fiddle://'+`${JSON.stringify(data)}`;
            }
        }).catch(err=> console.log(err))
    }
    const googleProvider = new GoogleAuthProvider()

    const singInWithGoogle = async () => {
        try {
            const result = await signInWithPopup(auth, googleProvider)
    
            const { displayName, email, photoURL, uid } = result.user
            console.log(displayName)
            return uid
    
        } catch (e) {
            alert((e).message)
        }
    }
    useEffect(()=>{
        SignInWithGoogle()
    },[])
  return (
    <div className='SignIn'>
      
    </div>
  )
}

export default SignIn
