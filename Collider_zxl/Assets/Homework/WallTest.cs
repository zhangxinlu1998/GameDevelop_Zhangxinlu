using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallTest : MonoBehaviour
{
    Transform thisTransform;
    public Transform[] wallTransforms; //4个墙的位置

    [SerializeField] float[] tempX = new float[2]; //0为负，1为正
    [SerializeField] float[] tempZ = new float[2]; //0为负，1为正

    public float bounceSpeed = 0.1f; //反弹速度
    Vector3 fDir;
    CollosionTest collosionTest;

    private void Start()
    {
        thisTransform = this.transform;
        collosionTest = this.GetComponent<CollosionTest>();
        

        for (int i = 0; i < wallTransforms.Length; i++)
            if (wallTransforms[i].position.x != 0)
            {
                if (wallTransforms[i].position.x < 0)
                    tempX[0] = wallTransforms[i].position.x;
                else if (wallTransforms[i].position.x > 0)
                    tempX[1] = wallTransforms[i].position.x;
            }
            else if (wallTransforms[i].position.z != 0)
            {
                if (wallTransforms[i].position.z < 0)
                    tempZ[0] = wallTransforms[i].position.z;
                else if (wallTransforms[i].position.z > 0)
                    tempZ[1] = wallTransforms[i].position.z;
            }
        StartCoroutine(ComputeDistance());
    }

    IEnumerator ComputeDistance()
    {
        CollosionTest collosionTest = this.GetComponent<CollosionTest>();
        while (true)
        {
            if (thisTransform.position.x <= tempX[0] + 1) //1为半径差
                StartCoroutine(Bounce(thisTransform.right * bounceSpeed));
            else if (thisTransform.position.x >= tempX[1] - 1) //1为半径差
                StartCoroutine(Bounce(-thisTransform.right * bounceSpeed));

            if (thisTransform.position.z <= tempZ[0] + 1) //1为半径差
                StartCoroutine(Bounce(thisTransform.forward * bounceSpeed));
            else if (thisTransform.position.z >= tempZ[1] - 1) //1为半径差
                StartCoroutine(Bounce(-thisTransform.forward * bounceSpeed));
            yield return null;
        }
    }

    IEnumerator Bounce(Vector3 dirVe3)
    {
        collosionTest.enabled = false;
        collosionTest.frictionDeltaV = Vector3.zero;
        collosionTest.curV = Vector3.zero;
        collosionTest.preV = Vector3.zero;
        while (Vector3.Distance(dirVe3, Vector3.zero) > 0.001f)
        {
            if (Vector3.Distance(dirVe3, Vector3.zero) < 0.1f)
                collosionTest.enabled = true;

            dirVe3 = Vector3.Lerp(dirVe3, Vector3.zero, Time.deltaTime);
            thisTransform.Translate(dirVe3);
            yield return new WaitForFixedUpdate();
        }
    }
}