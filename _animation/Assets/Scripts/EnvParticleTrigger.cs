using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class EnvParticleTrigger : MonoBehaviour
{
    private Animator ac;
    public GameObject player;
    public ParticleSystem attackParticleSys;
    public ParticleSystem kickParticleSys;
    private Cinemachine.CinemachineImpulseSource MyInpulse;

    Transform attackParticleParentTrans;
    Transform kickParticleParentTrans;

    private void Start()
    {
        ac = player.GetComponent<Animator>();
        MyInpulse = this.GetComponent<Cinemachine.CinemachineImpulseSource>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (ac.GetCurrentAnimatorStateInfo(0).IsName("Base Layer.attack"))
        {
            if (other.gameObject.tag == "Trigger" && attackParticleSys.isPlaying == false)
            {
                StartCoroutine(AttackParticleSysCtrl());
                MyInpulse.GenerateImpulse();
            }
        }
        if (ac.GetCurrentAnimatorStateInfo(0).IsName("Base Layer.kick"))
        {
            if (other.gameObject.tag == "Trigger" && kickParticleSys.isPlaying == false)
            {
                StartCoroutine(KickParticleSysCtrl());
                MyInpulse.GenerateImpulse();
            }
        }
    }

    IEnumerator AttackParticleSysCtrl()
    {
        Vector3 pos = attackParticleSys.transform.localPosition;
        attackParticleParentTrans = attackParticleSys.transform.parent;
        attackParticleSys.transform.parent = null;
        
        attackParticleSys.Play();
        
        yield return new WaitForEndOfFrame();
        while (attackParticleSys.isPlaying)
            yield return null;
        attackParticleSys.transform.parent = attackParticleParentTrans;
        attackParticleSys.transform.localPosition = pos;
    }

    IEnumerator KickParticleSysCtrl()
    {
        Vector3 pos = kickParticleSys.transform.localPosition;
        kickParticleParentTrans = kickParticleSys.transform.parent;
        kickParticleSys.transform.parent = null;

        kickParticleSys.Play();

        yield return new WaitForEndOfFrame();
        while (kickParticleSys.isPlaying)
            yield return null;
        kickParticleSys.transform.parent = kickParticleParentTrans;
        kickParticleSys.transform.localPosition = pos;
    }
}